from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tileset_basemap_no_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="tiles.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/basemap/{z}/{x}/{y}.pbf"


def test_get_tileset_basemap_with_proxy(connection):
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

    assert (
        answer["tiles"][0]
        == "https://test.com/some/url/tiles/pbf/basemap/{z}/{x}/{y}.pbf"
    )


def test_get_tileset_hillshade_no_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="tileset_v3.0.0_beta.json",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert answer["tiles"][0] == "http://mvt:8080/tiles/pbf/hillshade/{z}/{x}/{y}.pbf"


def test_get_tileset_hillshade_with_proxy(connection):
    """test the WFS connection -- cnx"""
    answer = connection.get_json(
        url="tileset_v3.0.0_beta.json",
        headers={
            "X-forwarded-host": "test.com",
            "X-Forwarded-Proto": "https",
            "Forwarded-Path": "/some/url",
        },
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )

    assert (
        answer["tiles"][0]
        == "https://test.com/some/url/tiles/pbf/hillshade/{z}/{x}/{y}.pbf"
    )
