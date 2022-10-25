from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tile(connection):
    answer = connection.get_raw(
        url="tiles/pbf/basemap//3/4/2.pbf",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert "application/vnd.mapbox-vector-tile" in answer.headers["content-type"]


def test_options_style(connection):
    """test OPTIONS with CORS"""
    answer = connection.options(
        url="tiles/pbf/basemap//3/4/2.pbf",
        cache_expected=CacheExpected.DONT_CARE,
        expected_status=204,
    )
    assert answer.headers.get("Access-Control-Allow-Origin") == "*"
