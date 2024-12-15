﻿filter Get-GitHubUserAllEmail {
    <#
        .SYNOPSIS
        List email addresses for the authenticated user

        .DESCRIPTION
        Lists all of your email addresses, and specifies which one is visible to the public.
        This endpoint is accessible with the `user:email` scope.

        .EXAMPLE
        Get-GitHubUserAllEmail

        Gets all email addresses for the authenticated user.

        .NOTES
        https://docs.github.com/rest/users/emails#list-email-addresses-for-the-authenticated-user

    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        # The number of results per page (max 100).
        [Parameter()]
        [ValidateRange(0, 100)]
        [int] $PerPage,

        # The context to run the command in. Used to get the details for the API call.
        # Can be either a string or a GitHubContext object.
        [Parameter()]
        [object] $Context = (Get-GitHubContext)
    )

    $Context = Resolve-GitHubContext -Context $Context

    $body = @{
        per_page = $PerPage
    }
    $inputObject = @{
        Context     = $Context
        APIEndpoint = '/user/emails'
        Method      = 'GET'
        Body        = $body
    }

    Invoke-GitHubAPI @inputObject | ForEach-Object {
        Write-Output $_.Response
    }

}
