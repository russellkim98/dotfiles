# Include interactive rc files
echo "${ZDOTDIR}"
for conffile in "${ZDOTDIR}"/rc.d/*; do
    source "${conffile}"
done

unset conffile

