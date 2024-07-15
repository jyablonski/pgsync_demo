from datetime import datetime
import os
import random
import time


from sqlalchemy import exc, create_engine, text
from sqlalchemy.engine.base import Connection, Engine


def sql_connection(
    rds_schema: str,
    rds_user: str = os.environ.get("RDS_USER", "postgres"),
    rds_pw: str = os.environ.get("RDS_PW", "postgres"),
    rds_ip: str = os.environ.get("IP", "postgres"),
    rds_db: str = os.environ.get("RDS_DB", "postgres"),
) -> Engine:
    """
    SQL Connection function to define the SQL Driver + connection
    variables needed to connect to the DB.

    This doesn't actually make the connection, use conn.connect()
    in a context manager to create 1 re-usable connection

    Args:
        rds_schema (str): The Schema in the DB to connect to.

    Returns:
        SQL Connection variable to a specified schema in my PostgreSQL DB
    """
    try:
        engine = create_engine(
            f"postgresql+psycopg2://{rds_user}:{rds_pw}@{rds_ip}:5432/{rds_db}",
            # pool_size=0,
            # max_overflow=20,
            connect_args={
                "options": f"-csearch_path={rds_schema}",
            },
            # defining schema to connect to
            echo=False,
        )
        print(f"SQL Engine for {rds_ip}:5432/{rds_db}/{rds_schema} created")
        return engine
    except exc.SQLAlchemyError as e:
        print(f"SQL Engine for {rds_ip}:5432/{rds_db}/{rds_schema} failed, {e}")
        raise e


def generate_fake_msg() -> dict[str, int]:
    payload = {
        "customer_id": random.randint(1, 5000),
        "event_id": random.randint(1, 5),
        "seat_id": random.randint(1, 15000),
    }

    return payload


if __name__ == "__main__":
    engine = sql_connection(
        rds_schema="source",
        rds_user="postgres",
        rds_pw="postgres",
        rds_ip="postgres",
        rds_db="postgres",
    )

    print("Sleeping 5 seconds to let the Database start up")
    time.sleep(5)
    invocations = 0
    with engine.begin() as conn:

        while True:
            if invocations > 100:
                print("Exiting ...")
                break
            else:
                invocations += 1
                payload = generate_fake_msg()
                print(f"Writing payload {payload} to Database")

                with engine.begin() as conn:
                    stmt = text(
                        "INSERT INTO source.customer_event_bookings (customer_id, event_id, seat_id) VALUES (:customer_id, :event_id, :seat_id)"
                    )
                    conn.execute(stmt, payload)
                time.sleep(10)
