import argparse
import csv

parser = argparse.ArgumentParser(description="Merge two excell files.")
parser.add_argument('-e', '--energy', required=True, help='First Excel file path')
parser.add_argument('-c', '--cost', required=True, help='Second Excel file path')
parser.add_argument('-o', '--output', help='Output Excel file name (optional)')
args = parser.parse_args()

print(args.energy)
print(args.cost)

energyPath = args.energy
costsPath = args.cost

table = list()
tableRow = -1

rowCounter = 2
currentDate = ""

currentHour = -1


print("Handling energy file:")
with open(energyPath, "r") as file:
    reader = csv.DictReader(file, delimiter="\t")
    row: dict
    for row in reader:
        print(f"    handling row {rowCounter}...")
        #print(rowCounter, " -> ", row)
        rowCounter += 1
        header = row.keys()

        dateSpecifier = list(header)[1]
        timeSpecifier = list(header)[2]
        energySpecifier = list(header)[7]

        date = row.get(dateSpecifier)
        time = row.get(timeSpecifier)
        energy = float(row.get(energySpecifier).replace(',', '.'))

        #print("DATUM::: ", date)
        #print("VRIJEME::: ", time)
        #print("ENERGIJA:::", energy)

        hour, minute, second = map(int, time.split(":"))

        #print("currentHour:", hour)
        #print("currentMinute:", minute)
        #print("currentSeconds:", second)

        if currentHour != hour:
            currentHour = hour

            if tableRow != -1:  # Skip first time
                table[tableRow][2] += energy # Add energy to last hour

            tableRow += 1   # Add a new row.
            table.append(list())

            table[tableRow].append(date)    # Fill new row with empty data.
            table[tableRow].append(hour + 1)
            table[tableRow].append(0)
        else:
            table[tableRow][2] += energy
table.pop()


rowCounter = 1
costTable = list()
print("Handling cost file...")
with open(costsPath, "r") as file:
    reader = csv.reader(file, delimiter="\t")
    for row in reader:
        #print(rowCounter, " -> ", row)
        clean_list = [item for item in row if item != '']
        costTable.append(clean_list[1::])
        rowCounter += 1
costTable = costTable[8:32:]

print("Adding costs to result table...")
numberOfDays = len(costTable[0]) // 2
totalEnergy = 0
totalEnergyNoCondition = 0
for i in range(len(costTable)):
    for day in range(numberOfDays):
        cost = costTable[i][day * 2]
        #print("COST::::", cost)
        cost = cost.replace("?","-")
        if "-" in cost:
            cost = cost.replace(",",".")
        cost = float(cost)
        index = i + 24*day
        table[index].append(cost)
        table[index].append(cost >= 0)
        totalEnergyNoCondition += table[index][2]
        if cost >= 0:
            totalEnergy += table[index][2]

        table[index][2] = str(table[index][2]).replace(".", ",")
        table[index][3] = str(table[index][3]).replace(".", ",")
    #print(costTable[i])



print("Printing results table:")
for i in range(len(table)):
    print(i, table[i])
print("Numbr of days:", numberOfDays)
print("Total energy:", totalEnergy)
print("Total energy no cond:", totalEnergyNoCondition)

with open('results.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, delimiter=';')  # Tab delimiter

    # Write header.
    writer.writerow(["Datum", "Sat", "Energija", "Cijena", "Status ukljucivanja"])

    # Write table data directly
    for row in table:
        safe_row = [v for v in row if not (isinstance(v, str) and v == "")]
        writer.writerow(safe_row)  # keeps 0 and 0.0

    # Add totals
    writer.writerow([])  # Empty row
    writer.writerow(['Total Energy', str(totalEnergy).replace(".",",")])
    writer.writerow(['Total Energy No Cond', str(totalEnergyNoCondition).replace(".", ",")])
