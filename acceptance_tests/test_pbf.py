from c2cwsgiutils.acceptance.connection import CacheExpected


def test_get_tile_basemap(connection):
    answer = connection.get_raw(
        url="tiles/pbf/basemap/3/4/2.pbf",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert "application/vnd.mapbox-vector-tile" in answer.headers["content-type"]


def test_get_tile_hillshade(connection):
    answer = connection.get_raw(
        url="tiles/pbf/hillshade/3/4/2.pbf",
        cache_expected=CacheExpected.DONT_CARE,
        cors=True,
    )
    assert "application/vnd.mapbox-vector-tile" in answer.headers["content-type"]
