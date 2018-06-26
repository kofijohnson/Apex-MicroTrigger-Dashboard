# MicroTrigger Dashboard

The MicroTrigger Dashboard displays real-time information about the Apex Triggers and Handlers that run in a specific DML transaction. It can also notify you when your Apex Trigger transaction hits a threshold limit that you set.

## Installing the MicroTrigger Dashboard

The MicroTrigger Dashboard is dependent on the [MicroTrigger Framework](https://github.com/kofijohnson/Apex-MicroTrigger) and [Apex TreeDiagram Library](https://github.com/kofijohnson/Apex-TreeDiagram), so they need to be installed/deployed in the Org or Scratch Org before the MicroTrigger Dashboard.

1. Clone the [MicroTrigger Framework repo](https://github.com/kofijohnson/Apex-MicroTrigger), then create an Unlocked Package and Unlocked Package version. In the [sfdx-project.json](https://github.com/kofijohnson/Apex-MicroTrigger/blob/master/sfdx-project.json) file, replace the MICROTRIGGERFRAMEWORK_PACKAGE_ID with the created Package ID.
2. Clone the [TreeDiagram Library repo](https://github.com/kofijohnson/Apex-TreeDiagram), then create an Unlocked Package and Unlocked Package version. In in the [sfdx-project.json](https://github.com/kofijohnson/Apex-MicroTrigger/blob/master/sfdx-project.json) file, replace the TREEDIAGRAMLIBRARY_PACKAGE_ID with the created Package ID.
3. Clone the current repo then create an Unlocked Package and Unlocked Package version. In the sfdx-project.json file, replace the replace the MICROTRIGGERFRAMEWORK_PACKAGE_ID with the MicroTrigger Package ID and the TREEDIAGRAMLIBRARY_PACKAGE_ID with the created TreeDiagram Library Package ID.

## How To Run the MicroTrigger Dashboard

To run the MicroTrigger, 

1. Create a Scratch Org, and install first the MicroTrigger Framework and the TreeDiagram packages, then the MicroTrigger Dashboard package in the Scratch Org,
2. Clone and deploy the [MicroTrigger Examples](https://github.com/kofijohnson/Apex-MicroTrigger-Examples) to the Scratch Org.
3. To view the Trigger Dashboard of a specific DML transaction, open the Visualforce Page "TreeDiagramPage", then run one of the [MicroTrigger Examples](https://github.com/kofijohnson/Apex-MicroTrigger-Examples).
4. To view the MicroTrigger Notifications, set the "DML Statements" or "SOQL Queries" fields of the Custom Settings "MicroTrigger Notification Settings" to 1. This will create a MicroTrigger Notification (Custom Object) record, each time the DML Statement or SOQL Limit in a Trigger transaction is over 1%.
