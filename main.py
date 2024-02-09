from pycarol import Staging, Carol
from dotenv import load_dotenv

load_dotenv(".env")

staging = Staging(Carol())
schema = staging.get_schema(staging_name="users",
    connector_name="lscloud")
print(schema)

df = staging.fetch_parquet(
    staging_name="users",
    connector_name="lscloud",
    backend='pandas',
    max_hits=100,
    return_metadata=False,
    columns=['idProductLine', 'packageId']
)

print(df)