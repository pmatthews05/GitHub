﻿class GitHubVariable {
    # The name of the variable.
    [string] $Name

    # The value of the variable.
    [string] $Value

    # The name of the organization or user the variable is associated with.
    [string] $Owner

    # The name of the repository the variable is associated with.
    [string] $Repository

    # The name of the environment the variable is associated with.
    [string] $Environment

    # The date and time the variable was created.
    [datetime] $CreatedAt

    # The date and time the variable was last updated.
    [datetime] $UpdatedAt

    # The visibility of the variable.
    [string] $Visibility

    # The ids of the repositories that the variable is visible to.
    [GitHubRepository[]] $SelectedRepositories

    # Simple parameterless constructor
    GitHubVariable() {}

    # Creates a object from a hashtable of key-vaule pairs.
    GitHubVariable([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }

    # Creates a object from a PSCustomObject.
    GitHubVariable([PSCustomObject]$Object) {
        $Object.PSObject.Properties | ForEach-Object {
            $this.($_.Name) = $_.Value
        }
    }
}
