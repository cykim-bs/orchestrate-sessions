<#
.SYNOPSIS
    Install the orchestrate-sessions skill and the model-effort-by-task rule for Claude Code.

.DESCRIPTION
    Copies
      skills/orchestrate-sessions/     -> <base>/skills/orchestrate-sessions/
      rules/model-effort-by-task.md    -> <base>/rules/model-effort-by-task.md
    where <base> is ~/.claude (default) or <Project>/.claude (-Project).

    Existing files are left alone unless -Force is given. With -Force the old copy is
    moved to <base>/orchestrate-sessions-backup/<timestamp>/ first (outside skills/ and rules/,
    so Claude Code does not load it twice), and an existing local-bindings.md is carried over.

.EXAMPLE
    .\scripts\install.ps1 -WhatIf
    .\scripts\install.ps1
    .\scripts\install.ps1 -Project C:\work\my-app
    .\scripts\install.ps1 -Force
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Project,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillSrc = Join-Path $repoRoot 'skills\orchestrate-sessions'
$ruleSrc  = Join-Path $repoRoot 'rules\model-effort-by-task.md'

if ($Project) {
    if (-not (Test-Path -LiteralPath $Project -PathType Container)) { throw "Project folder not found: $Project" }
    $base = Join-Path (Resolve-Path -LiteralPath $Project).Path '.claude'
} else {
    $base = Join-Path $HOME '.claude'
}

$skillDst = Join-Path $base 'skills\orchestrate-sessions'
$ruleDst  = Join-Path $base 'rules\model-effort-by-task.md'
$stamp    = Get-Date -Format 'yyyyMMddHHmmss'
$bakRoot  = Join-Path $base "orchestrate-sessions-backup\$stamp"

Write-Host "Install target: $base"

function Install-Item {
    param([string]$Src, [string]$Dst, [switch]$IsDir)

    $parent = Split-Path -Parent $Dst
    $bindings = $null

    if (Test-Path -LiteralPath $Dst) {
        if (-not $Force) {
            Write-Warning "Already exists, skipped: $Dst  (use -Force to replace; the old copy is backed up)"
            return
        }
        $bak = Join-Path $bakRoot (Split-Path -Leaf $Dst)
        if ($PSCmdlet.ShouldProcess($Dst, "Back up to $bak")) {
            if (-not (Test-Path -LiteralPath $bakRoot)) { New-Item -ItemType Directory -Path $bakRoot -Force | Out-Null }
            Move-Item -LiteralPath $Dst -Destination $bak
            Write-Host "Backed up: $bak"
            if ($IsDir) {
                $old = Join-Path $bak 'references\local-bindings.md'
                if (Test-Path -LiteralPath $old) { $bindings = $old }
            }
        }
    }

    if ($PSCmdlet.ShouldProcess($Dst, "Copy from $Src")) {
        if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        if ($IsDir) { Copy-Item -LiteralPath $Src -Destination $Dst -Recurse }
        else        { Copy-Item -LiteralPath $Src -Destination $Dst }
        Write-Host "Installed: $Dst"
        if ($bindings) {
            Copy-Item -LiteralPath $bindings -Destination (Join-Path $Dst 'references\local-bindings.md')
            Write-Host "Kept your local-bindings.md"
        }
    }
}

Install-Item -Src $skillSrc -Dst $skillDst -IsDir
Install-Item -Src $ruleSrc  -Dst $ruleDst

Write-Host ""
Write-Host "Done. Start a NEW Claude Code conversation to use it."
Write-Host "Optional: copy references\local-bindings.example.md to references\local-bindings.md and edit it."
