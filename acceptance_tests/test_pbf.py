def test_get_tile(connection):
    answer = connection.get_raw(
        url="tiles/pbf/3/4/2.pbf",
        cors=True,
    )
    assert answer.headers["content-type"] == "application/vnd.mapbox-vector-tile"
