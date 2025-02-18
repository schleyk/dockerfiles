# build mkp224o:
docker build --rm -t mkp224o .

# generate your onion domain with "test" prefix:
docker run --rm -v $(pwd)/out:/out mkp224o test -d /out