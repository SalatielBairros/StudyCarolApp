
FROM totvslabs/pycarol:2.30.0

env SRCFOLDER=src

WORKDIR /app
ADD requirements.txt /app/
ADD src/ /app/studyapp/

RUN pip install -r requirements.txt && \
  pip install gunicorn

EXPOSE 5000

VOLUME [ "/app" ]

CMD ["gunicorn", "-c", "/app/studyapp/gunicorn.conf.py", "studyapp.alg_studyapp:application"]
