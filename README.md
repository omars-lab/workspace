# environment
My personal unix development environment.

### Setup Instructions:
* Change the Identitiy file in ssh/config and move it to .ssh/config
* Change the git/gitconfig files username and email and move it to ~/.gitconfig
* Change variables in the variables.sh file
* Add a line to ~/.bash_profile to source loader.sh


--
##### Depricated
```
To create more functions and wrapper:
Create a file for each main function and place it in the functions dir.
Create a python file containing the possible choices for each command.
Import the newly created file and map it to a function that will return all possible choices when called in the __init__.py file's function_choices dict in the autocompleter dir.
```
--
