Task azure-checkout -description 'Checks out to a local branch.' `
{
    $tag = $null
    $branch = $null

    if ($env:BUILD_SOURCEBRANCH -like 'refs/tags/*')
    {
        $tag = $env:BUILD_SOURCEBRANCHNAME
    }

    if ($tag)
    {
        $branches = Exec { git branch -r  --format="%(refname:short)" --contains $tag }
        if (($branches | Select-String '^origin/master$').Length -eq 1)
        {
            $branch = 'master'
        }
        else
        {
            throw "Unexpected tag: $tag"
        }
    }
    elseif ($env:BUILD_SOURCEBRANCH -match 'refs/heads/(.*)')
    {
        $branch = $Matches[1]
    }
    else
    {
        throw "Wrong reference: $($env:BUILD_SOURCEBRANCH)"
    }

    Exec { git checkout -B $branch $env:BUILD_SOURCEVERSION }
}
