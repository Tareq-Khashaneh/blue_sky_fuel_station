# blue_sky_station

This Flutter-based POS application is designed to streamline fuel pump management at stations using the Nexgo N86 device. It integrates real-time pump control, card reading, and transaction handling, making operations efficient for both operators and customers. The app features a clean UI with GetX state management and uses TCP socket communication to interact with the pumps and POS devices.

## Key Features:
1. Real-time pump control: Manage pump operations such as start/stop, preset volumes, and price settings via TCP socket communication.
2. POS system integration: Seamless interaction with POS devices, enabling card reading, receipt printing, and handling customer transactions.
3. Auto-ON/OFF Pump Control:
 - Auto-ON: When the card is scanned or a preset fuel volume is selected, the pump automatically powers on and begins dispensing fuel. The system monitors the nozzle and fuel amount in real-time.
 - Auto-OFF: Once the fuel reaches the preset limit or a timeout occurs (e.g., nozzle not lifted), the pump automatically turns off, ensuring resource efficiency.
4. Data management: Leverages GetX for efficient state and data handling, and uses API connections for server communication.
5. Secure user authentication: Ensures only authorized users can access pump controls and transaction data.
6. Transaction logging and receipt printing: Supports transaction record keeping and printing of receipts using the POS printer.
7. Flexible API integration: Allows for easy integration with back-end systems and databases for transaction records and analytics.

## images link
https://t.me/tareq_khashaneh_portfolio

