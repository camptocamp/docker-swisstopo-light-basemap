from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_style_base_no_proxy(connection):
    """test get style for basemap"""
    answer = connection.get_json(
        url="style.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert (
        answer["sources"]["base_v1.0.0"]["url"] == "http://mvt:8080/tiles/tiles_base.json"
    )


def test_get_style_relief_no_proxy(connection):
    """test get style for relief"""
    answer = connection.get_json(
        url="style.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert (
        answer["sources"]["terrain_v1.0.0"]["url"] == "http://mvt:8080/tiles/tiles_relief.json"
    )


def test_options_style(connection):
    """test OPTIONS with CORS"""
    answer = connection.options(
        url="style.json",
        cache_expected=CacheExpected.DONT_CARE,
        expected_status=204,
    )
    assert answer.headers.get("Access-Control-Allow-Origin") == "*"


def test_get_style_base_with_proxy(connection):
    """test get style for basemap with proxy settings"""
    answer = connection.get_json(
        url="style.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "X-Forwarded-Prefix": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert (
        answer["sources"]["base_v1.0.0"]["url"]
        == "https://test.com/some/url/tiles/tiles_base.json"
    )


def test_get_style_relief_with_proxy(connection):
    """test get style for relief with proxy settings"""
    answer = connection.get_json(
        url="style.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "X-Forwarded-Prefix": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert (
        answer["sources"]["terrain_v1.0.0"]["url"]
        == "https://test.com/some/url/tiles/tiles_relief.json"
    )
