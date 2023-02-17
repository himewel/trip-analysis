from google.cloud import bigquery
from google.cloud.bigquery import SchemaField, Table

_PROJECT = "jobsity-17022023"
_DATASET = "jobsity_trips"

class BigQueryDefinitions:
    def __init__(self):
        self.landing_table_id = f"{_PROJECT}.{_DATASET}.landing_trips"
        self.refined_view_id = f"{_PROJECT}.{_DATASET}.refined_trips"
        self.client = bigquery.Client()

    def create_refined_view(self):
        view = Table(self.refined_view_id)
        view.mview_query = f"""
            SELECT
                region,
                ST_GEOGFROMTEXT(origin_coord) origin_coord,
                ST_GEOGFROMTEXT(destination_coord) destination_coord,
                datetime,
                datasource
            FROM `{self.landing_table_id}`
        """
        view = self.client.create_table(view, exists_ok=True)  # Make an API request.
        print(f"Created view {view.table_type}: {str(view.reference)}")
    
    def run(self):
        self.create_refined_view()


if __name__ == "__main__":
    BigQueryDefinitions().run()