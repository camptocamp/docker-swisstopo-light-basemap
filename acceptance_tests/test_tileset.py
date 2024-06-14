from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tileset_base_no_proxy(connection):
    """test get tiles_base.json"""
    answer = connection.get_json(
        url="tiles_base.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/basemap/{z}/{x}/{y}.pbf"


def test_get_tileset_relief_no_proxy(connection):
    """test get tiles_base.json"""
    answer = connection.get_json(
        url="tiles_relief.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/relief/{z}/{x}/{y}.pbf"


def test_options_style_base(connection):
    """test OPTIONS with CORS for basemap"""
    answer = connection.options(
        url="tiles_base.json",
        cache_expected=CacheExpected.DONT_CARE,
        expected_status=204,
    )
    assert answer.headers.get("Access-Control-Allow-Origin") == "*"


def test_options_style_relief(connection):
    """test OPTIONS with CORS for relief"""
    answer = connection.options(
        url="tiles_relief.json",
        cache_expected=CacheExpected.DONT_CARE,
        expected_status=204,
    )
    assert answer.headers.get("Access-Control-Allow-Origin") == "*"


def test_get_tileset_base_with_proxy(connection):
    """test get tiles_base.json with proxy"""
    answer = connection.get_json(
        url="tiles_base.json",
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


def test_get_tileset_relief_with_proxy(connection):
    """test get tiles_relief.json with proxy"""
    answer = connection.get_json(
        url="tiles_relief.json",
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
        == "https://test.com/some/url/tiles/pbf/relief/{z}/{x}/{y}.pbf"
    )
