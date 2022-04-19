from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_style_no_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="style.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert (
        answer["sources"]["swissmaptiles"]["url"] == "http://mvt:8080/tiles/tiles.json"
    )


def test_get_style_with_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="style.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "Forwarded-Path": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert (
        answer["sources"]["swissmaptiles"]["url"]
        == "https://test.com/some/url/tiles/tiles.json"
    )
