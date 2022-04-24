function password-set() {
  # https://www.netmeister.org/blog/keychain-passwords.html#:~:text=To%20add%20a%20secret%20to,line%20utility%20security(1).&text=After%20clicking%20'Add'%2C%20your,available%20in%20the%20login%20keychain.
  PASS=$(cat)
  security add-generic-password -a ${USER} -s ${1} -w "${PASS}" -U
}

function password-get() {
  security find-generic-password -a ${USER} -s ${1} -w
}