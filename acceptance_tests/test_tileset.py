from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tileset_no_proxy(connection):
    """test get tiles.json"""
    answer = connection.get_json(
        url="tiles.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/basemap/{z}/{x}/{y}.pbf"


def test_options_style(connection):
    """test OPTIONS with CORS"""
    answer = connection.options(
        url="tiles.json",
        cache_expected=CacheExpected.DONT_CARE,
        expected_status=204,
    )
    assert answer.headers.get("Access-Control-Allow-Origin") == "*"


def test_get_tileset_with_proxy(connection):
    """test get tiles.json with proxy"""
    answer = connection.get_json(
        url="tiles.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "X-Forwarded-Prefix": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert (
        answer["tiles"][0]
        == "https://test.com/some/url/tiles/pbf/basemap/{z}/{x}/{y}.pbf"
    )
