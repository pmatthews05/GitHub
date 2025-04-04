﻿filter New-GitHubRelease {
    <#
        .SYNOPSIS
        Create a release

        .DESCRIPTION
        Users with push access to the repository can create a release.
        This endpoint triggers [notifications](https://docs.github.com/github/managing-subscriptions-and-notifications-on-github/about-notifications).
        Creating content too quickly using this endpoint may result in secondary rate limiting.
        See "[Secondary rate limits](https://docs.github.com/rest/overview/resources-in-the-rest-api#secondary-rate-limits)"
        and "[Dealing with secondary rate limits](https://docs.github.com/rest/guides/best-practices-for-integrators#dealing-with-secondary-rate-limits)" for details.

        .EXAMPLE
        New-GitHubRelease -Owner 'octocat' -Repository 'hello-world' -TagName 'v1.0.0' -TargetCommitish 'main' -Body 'Release notes'

        Creates a release for the repository 'octocat/hello-world' with the tag 'v1.0.0' and the target commitish 'main'.

        .NOTES
        [Create a release](https://docs.github.com/rest/releases/releases#create-a-release)
    #>
    [OutputType([pscustomobject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidLongLines', '', Justification = 'Contains a long link.')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The account owner of the repository. The name is not case sensitive.
        [Parameter(Mandatory)]
        [Alias('Organization')]
        [Alias('User')]
        [string] $Owner,

        # The name of the repository without the .git extension. The name is not case sensitive.
        [Parameter(Mandatory)]
        [string] $Repository,

        # The name of the tag.
        [Parameter(Mandatory)]
        [Alias('tag_name')]
        [string] $TagName,

        # Specifies the commitish value that determines where the Git tag is created from.
        # Can be any branch or commit SHA. Unused if the Git tag already exists.
        # API Default: the repository's default branch.
        [Parameter()]
        [Alias('target_commitish')]
        [string] $TargetCommitish = 'main',

        # The name of the release.
        [Parameter()]
        [string] $Name,

        # Text describing the contents of the tag.
        [Parameter()]
        [string] $Body,

        # Whether the release is a draft.
        [Parameter()]
        [switch] $Draft,

        # Whether to identify the release as a prerelease.
        [Parameter()]
        [switch] $Prerelease,

        # If specified, a discussion of the specified category is created and linked to the release.
        # The value must be a category that already exists in the repository.
        # For more information, see [Managing categories for discussions in your repository](https://docs.github.com/discussions/managing-discussions-for-your-community/managing-categories-for-discussions-in-your-repository).
        [Parameter()]
        [Alias('discussion_category_name')]
        [string] $DiscussionCategoryName,

        # Whether to automatically generate the name and body for this release. If name is specified, the specified name will be used; otherwise,a name will be automatically generated. If body is specified, the body will be pre-pended to the automatically generated notes.
        [Parameter()]
        [Alias('generate_release_notes')]
        [switch] $GenerateReleaseNotes,

        # Specifies whether this release should be set as the latest release for the repository. Drafts and prereleases cannot be set as latest. Defaults to true for newly published releases. legacy specifies that the latest release should be determined based on the release creation date and higher semantic version.
        [Parameter()]
        [Alias('make_latest')]
        [ValidateSet('true', 'false', 'legacy')]
        [string] $MakeLatest = 'true',

        # The context to run the command in. Used to get the details for the API call.
        # Can be either a string or a GitHubContext object.
        [Parameter()]
        [object] $Context = (Get-GitHubContext)
    )

    begin {
        $stackPath = Get-PSCallStackPath
        Write-Debug "[$stackPath] - Start"
        $Context = Resolve-GitHubContext -Context $Context
        Assert-GitHubContext -Context $Context -AuthType IAT, PAT, UAT
    }

    process {
        $body = @{
            tag_name                 = $TagName
            target_commitish         = $TargetCommitish
            name                     = $Name
            body                     = $Body
            discussion_category_name = $DiscussionCategoryName
            make_latest              = $MakeLatest
            generate_release_notes   = $GenerateReleaseNotes
            draft                    = $Draft
            prerelease               = $Prerelease
        }
        $body | Remove-HashtableEntry -NullOrEmptyValues

        $inputObject = @{
            Method      = 'POST'
            APIEndpoint = "/repos/$Owner/$Repository/releases"
            Body        = $body
            Context     = $Context
        }

        if ($PSCmdlet.ShouldProcess("$Owner/$Repository", 'Create a release')) {
            Invoke-GitHubAPI @inputObject | ForEach-Object {
                Write-Output $_.Response
            }
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
