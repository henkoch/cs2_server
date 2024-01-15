#!/usr/bin/env python3

# pip install elasticsearch

from elasticsearch import Elasticsearch
import datetime

# Get the current date and time
current_time = datetime.datetime.now()

# Connect to Elasticsearch instance
client = Elasticsearch("http://localhost:9200")

# Define your Elasticsearch index and query
index_name = 'cs2'
query = {
    "query": {
        "match": {
            "action": "killed"
        }
    }
}

# Perform the search
# I think the size is the number of records
search_results = client.search(index=index_name, body=query, size=10000)

number_of_entries = 0

kill_data = []

for hit in search_results['hits']['hits']:
    number_of_entries += 1
    source = hit['_source']
    kill_data.append({
        'timestamp': source['@timestamp'],
        'killer': source['killer_username'],
        'victim': source['victim_username'],
        # Add more fields as needed
    })

kill_dictionary = {}
death_dictionary = {}

# Calculate the total kills
for kill in kill_data:
    if kill['killer'] in kill_dictionary:
      kill_dictionary[kill['killer']] = kill_dictionary[kill['killer']] + 1
    else:
      kill_dictionary[kill['killer']] = 1

    if kill['victim'] in death_dictionary:
      death_dictionary[kill['victim']] = death_dictionary[kill['victim']] + 1
    else:
      death_dictionary[kill['victim']] = 1

# Caculate total kills
total_kills = 0
for killer in kill_dictionary:
   total_kills += kill_dictionary[killer]
   if killer not in death_dictionary:
       death_dictionary[killer] = 0

for victim in death_dictionary:
   if victim not in kill_dictionary:
       kill_dictionary[victim] = 0


sorted_dict = dict(sorted(kill_dictionary.items(), key=lambda item: item[1], reverse=True))

print("<html><title>CS2 statistics</title>")
print("<head><meta http-equiv=\"refresh\" content=\"30\"></head>")
print("<table>")
print("<tr><td>Name</td><td>Kills</td><td>Deaths</td><td>K/D ratio</td><td>Rating</td></tr>")

# Print the sorted dictionary
for killer in sorted_dict:
   kill_death_ratio = 0
   if death_dictionary[killer] == 0:
      kill_death_ratio = '*'
   else:
      kill_death_ratio = formatted_value = "{:.2f}".format(sorted_dict[killer]/death_dictionary[killer])
   kill_rating = formatted_value = "{:.0f}".format(100*sorted_dict[killer]/total_kills)
   print("<tr>")
   print(f"<td>{killer}</td><td style=\"text-align: right;\">{sorted_dict[killer]}</td><td style=\"text-align: right;\">{death_dictionary[killer]}</td><td style=\"text-align: right;\">{kill_death_ratio}</td><td style=\"text-align: right;\">{kill_rating}</td>")
   print("</tr>")

print("</table>")
formatted_time = current_time.strftime("%Y-%m-%d %H:%M:%S")
print(f"<p>number of records from db: {number_of_entries}</p>")
print(formatted_time)
print("</html>")

