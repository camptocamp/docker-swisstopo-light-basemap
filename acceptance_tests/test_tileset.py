from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tileset_no_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="tiles.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/{z}/{x}/{y}.pbf"


def test_get_tileset_with_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="tiles.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "Forwarded-Path": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "https://test.com/some/url/tiles/pbf/{z}/{x}/{y}.pbf"
