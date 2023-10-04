from azure.servicebus import ServiceBusClient, ServiceBusMessage

connection_string = dbutils.secrets.get(scope="keyvault-managed", key="servicebusconnectionstring")

with ServiceBusClient.from_connection_string(connection_string) as client:
    with client.get_queue_sender("databricks") as sender:
        single_message = ServiceBusMessage("Hello from Databricks!")
        test = sender.send_messages(single_message)
        print(f"Message enqueed: {single_message.message_id}")
