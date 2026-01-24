# workspace
*Capturing my personal working environment*

My personal unix development environment.

For detailed information about the ZSH configuration and loader system, see [docs/loader.md](docs/loader.md).

### Setup Instructions:
* Change the Identitiy file in ssh/config and move it to .ssh/config
* Change the git/gitconfig files username and email and move it to ~/.gitconfig
* Change variables in the variables.sh file
* Add a line to ~/.bash_profile to source loader.sh


------------------------------------------
### Prerequisites
- virtualenvwrapper:
    - installation:
        1. Install virtual env: pip install virtualenvwrapper
        2. Create a directory to hold the virtual environments.
        3. Add a line like "export WORKON_HOME=<Virtual Envs Home>" to your .bashrc.
        4. source virtualenvwrapper

------------------------------------------
##### Depricated
```
To create more functions and wrapper:
Create a file for each main function and place it in the functions dir.
Create a python file containing the possible choices for each command.
Import the newly created file and map it to a function that will return all possible choices when called in the __init__.py file's function_choices dict in the autocompleter dir.
```
-----------------------------------------------
