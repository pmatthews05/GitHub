﻿filter Stop-GitHubWorkflowRun {
    <#
        .SYNOPSIS
        Cancel a workflow run

        .DESCRIPTION
        Cancels a workflow run using its `run_id`. You can use this endpoint to cancel a workflow run that is in progress or waiting

        .EXAMPLE
        Stop-GitHubWorkflowRun -Owner 'octocat' -Repo 'Hello-World' -ID 123456789

        Cancels the workflow run with the ID 123456789 from the 'Hello-World' repository owned by 'octocat'

        .NOTES
        [Cancel a workflow run](https://docs.github.com/en/rest/actions/workflow-runs#cancel-a-workflow-run)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [alias('Cancel-GitHubWorkflowRun')]
    param(
        [Parameter()]
        [string] $Owner,

        [Parameter()]
        [string] $Repo,

        [Alias('workflow_id')]
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string] $ID,

        # The context to run the command in. Used to get the details for the API call.
        # Can be either a string or a GitHubContext object.
        [Parameter()]
        [object] $Context = (Get-GitHubContext)
    )

    $Context = Resolve-GitHubContext -Context $Context

    if ([string]::IsNullOrEmpty($Owner)) {
        $Owner = $Context.Owner
    }
    Write-Debug "Owner : [$($Context.Owner)]"

    if ([string]::IsNullOrEmpty($Repo)) {
        $Repo = $Context.Repo
    }
    Write-Debug "Repo : [$($Context.Repo)]"

    $inputObject = @{
        Context     = $Context
        Method      = 'POST'
        APIEndpoint = "/repos/$Owner/$Repo/actions/runs/$ID/cancel"
    }

    if ($PSCmdlet.ShouldProcess("workflow run with ID [$ID] in [$Owner/$Repo]", 'Cancel/Stop')) {
        Invoke-GitHubAPI @inputObject | ForEach-Object {
            Write-Output $_.Response
        }
    }
}
