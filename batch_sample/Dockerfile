
FROM totvslabs/pycarol:2.30.0

WORKDIR /app
ADD requirements.txt /app/
ADD batch_sample/ /app/batch_sample/

RUN pip install -r requirements.txt

VOLUME [ "/app" ]

CMD ["python3", "-m", "batchstudyproject.batchstudyproject_algorithm"]
