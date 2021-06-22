.PHONY: graphql/gen-idl
graphql/gen-idl:
	bin/rake graphql:schema:idl
