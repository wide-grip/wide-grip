#! /bin/bash
docker run -p 8080:8080 -p 5432:5432 \
       -e HASURA_GRAPHQL_DATABASE_URL=postgres://andrewmacmurray:@host.docker.internal:5432/wide_grip \
       -e HASURA_GRAPHQL_ENABLE_CONSOLE=false \
       hasura/graphql-engine:v1.0.0-alpha44
