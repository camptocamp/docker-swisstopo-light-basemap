from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tile(connection):
    answer = connection.get_raw(
        url="tiles/pbf/3/4/2.pbf",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert "application/vnd.mapbox-vector-tile" in answer.headers["content-type"]
