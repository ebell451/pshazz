function global:git_prompt_info {
    try { $ref = git symbolic-ref HEAD } catch { }
    if($ref) {
        $ref = $ref -replace '^refs/heads/', ''
        write-host " $ref" -f red -nonewline

        try { $status = git status --porcelain } catch { }
        if($status) {
            write-host "*" -f red -nonewline
        }
    }
}

function global:prompt {
    $saveexitcode = $lastexitcode
    write-host "ex$lastexitcode" -f green -nonewline
    write-host '$ ' -f darkblue -nonewline 
    write-host "$(split-path $pwd -leaf)" -f cyan -nonewline
    git_prompt_info

    $global:lastexitcode = $saveexitcode
    " "
}

# prompt 
# $executionContext.invokeCommand.expandString("$pwd")
