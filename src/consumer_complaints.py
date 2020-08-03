# This code decrypts a .csv file initially for reading the data.
# Finally, data meeting the criteria are extracted and outputted.

# Importing the required modules
import csv
import datetime

# Reading data file (.csv)
with open("../input/complaints.csv", newline='', encoding="utf8") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')

# Counters are required to count the desired changes
    count1 = 0
    count2 = 0
    count3 = 0
    count4 = 0
    count5 = 0

    statement_1 = "Credit reporting, credit repair services, or other personal consumer reports"
    statement_2 = "debt collection"
    for row in csv_reader:
        for i in range(2019, 2020):
            datetime_object1 = str(datetime.date(i, 1, 1))
            datetime_object2 = str(datetime.date(i + 1, 1, 1))
            if '2019-1-1' < row[0] < '2020-1-1':
                if row[1] == statement_1:
                    count1 += 1
            elif '2018-1-1' < row[0] < '2019-1-1':
                if row[1] == statement_1:
                    count2 += 1

with open("../input/complaints.csv", newline='', encoding="utf8") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')

    for row in csv_reader:
        row = str(row)
        result1 = row.find('TRANSUNION INTERMEDIATE HOLDINGS, INC.')
        result2 = row.find('TRANSWORLD SYSTEMS INC')
        result3 = row.find('Debt collection')

        if result1 != -1:
            count3 += 1

        if result2 != -1:
            count4 += 1

        if result3 != -1:
            count5 += 1

# Recording the outputs in a (.csv) file
with open("../output/report.csv", 'w') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow([statement_1.lower(), '2019', count1, count3, round(100*(count3/count1))])
    csv_writer.writerow([statement_1.lower(), '2020', count2, count4, round(100*(count4/count2))])
    csv_writer.writerow([statement_2.lower(), '2019', count2, count5, round(100*(count5/count2))])