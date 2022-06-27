# sfdx.nvim

A neovim toolset for sfdx!

## About

This is an abstraction to the Salesforce cli so that you can run certain commands in your neovim command editor.

## Installation

Using packer

```
use {"leviticusnelson/sfdx.nvim"}
```

## Commands

Deploying an apex file or LWC to default org while in buffer (note .xml files are not implemented yet):

```
:SfdxDeploy
```

Running a test on the org:

```
:SfdxTest
```
