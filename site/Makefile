
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
        $(error Undefined $1$(if $2, ($2))$(if $(value @), \
                required by target `$@')))

SOURCE=public
all:
	@echo "Use publish to push to the hosting"

publish:
	hugo
	@:$(call check_defined, AWS_ACCESS_KEY_ID, AWS access key)
	@:$(call check_defined, AWS_SECRET_ACCESS_KEY, AWS secret access key)
	@:$(call check_defined, TARGET, Target bucket)
	@echo "Syncing ${SOURCE} to ${TARGET}"
	aws s3 sync --delete ${SOURCE} ${TARGET} 
