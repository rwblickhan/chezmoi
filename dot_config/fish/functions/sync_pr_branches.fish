function sync_pr_branches
    # Check if gh is installed
    if not command -v gh &>/dev/null
        echo "Error: GitHub CLI (gh) is not installed"
        echo "Install from: https://cli.github.com/"
        return 1
    end

    # Check if we're in a git repository
    if not git rev-parse --git-dir &>/dev/null
        echo "Error: Not in a git repository"
        return 1
    end

    echo "Checking local branches..."

    set local_branches (git branch --format='%(refname:short)')
    
    if test (count $local_branches) -eq 0
        echo "No local branches found"
        return 0
    end

    echo "Found "(count $local_branches)" local branch(es)"
    echo ""

    set current_branch (git branch --show-current)
    set open_pr_branches (gh pr list --state open --author "@me" --json headRefName --jq '.[].headRefName' 2>/dev/null)

    for branch in $local_branches
        if test "$branch" = "$current_branch"
            echo (set_color yellow)"⊘ Skipping '$branch' (currently checked out)"(set_color normal)
            continue
        end

        if git worktree list | grep -q "\\[$branch\\]"
            echo (set_color yellow)"⊘ Skipping '$branch' (has attached worktree)"(set_color normal)
            continue
        end

        set pr_state (gh pr list --state all --head $branch --json state --jq '.[0].state' 2>/dev/null)

        if test -z "$pr_state"
            echo (set_color yellow)"⊘ Skipping '$branch' (no PR found)"(set_color normal)
            continue
        end

        if test "$pr_state" = "CLOSED" -o "$pr_state" = "MERGED"
            if git branch -D $branch &>/dev/null
                echo (set_color green)"✓ Deleted branch '$branch' (PR state: $pr_state)"(set_color normal)
            else
                echo (set_color red)"✗ Failed to delete branch '$branch'"(set_color normal)
            end
        else
            echo (set_color yellow)"⊘ Skipping '$branch' (open PR found)"(set_color normal)
        end
    end

    for branch in $open_pr_branches
        if contains -- $branch $local_branches
            continue
        end

        if git fetch origin $branch:$branch &>/dev/null
            echo (set_color green)"✓ Recreated branch '$branch'"(set_color normal)
        else
            echo (set_color red)"✗ Failed to recreate branch '$branch'"(set_color normal)
        end
    end
end
