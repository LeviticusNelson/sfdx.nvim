# sfdx.nvim

A neovim toolset for sfdx written 100% in lua!

## About

This is an abstraction to the Salesforce cli so that you can run certain commands in your neovim command editor.

## Installation

Using packer

```
use {"leviticusnelson/sfdx.nvim"}
```

## Commands

Setting default username:

```
:SfdxSetUsername {name}
```

Deploying an apex file or LWC to default org while in buffer (note .xml files are not implemented yet):

```
:SfdxDeploy
```

Running a test on the org:

```
:SfdxTest
```

## Roadmap (not in order)

- [ ] Make a popup window to view all of the result information
- [ ] Add more sfdx commands to use
- [ ] Configure each command with your own args
- [ ] Add logic for running a command while an .xml file is loaded in buffer
- [ ] Add soql query execution
- [ ] Add CI tools for automated testing
