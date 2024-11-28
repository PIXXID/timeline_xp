import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:timeline_xp/timeline_xp.dart';

void main() {
  const projectCount = 2;

  final dateInterval = {
    "prj_startdate": "2024-02-26",
    "prj_enddate": "2024-12-31"
  };

  final elements = [
    {
      "pre_date": "2024-03-02",
      "activity_total": 1,
      "activity_completed": 0,
      "delivrable_total": 0,
      "delivrable_completed": 0,
      "task_total": 0,
      "task_completed": 0,
      "hustle": 1
    },
    {
      "pre_date": "2024-09-16",
      "activity_total": 2,
      "activity_completed": 0,
      "delivrable_total": 1,
      "delivrable_completed": 1,
      "task_total": 0,
      "task_completed": 0,
      "hustle": 1
    },
    {
      "pre_date": "2024-09-18",
      "activity_total": 2,
      "activity_completed": 0,
      "delivrable_total": 0,
      "delivrable_completed": 0,
      "task_total": 1,
      "task_completed": 0,
      "hustle": 1
    }
  ];
  final capacities = [
    {
      "upc_date": "2024-09-13",
      "capacity_level_max": 6,
      "upc_capacity_effort": 6,
      "upc_busy_effort": 4,
      "upc_completed_effort": 1,
      "upc_my_busy_effort": 4,
      "upc_my_completed_effort": 1
    },
    {
      "upc_date": "2024-09-16",
      "capacity_level_max": 4,
      "upc_capacity_effort": 4,
      "upc_busy_effort": 3,
      "upc_completed_effort": 2,
      "upc_my_busy_effort": 3,
      "upc_my_completed_effort": 2
    },
    {
      "upc_date": "2024-09-23",
      "capacity_level_max": 13,
      "upc_capacity_effort": 13,
      "upc_busy_effort": 7,
      "upc_completed_effort": 3,
      "upc_my_busy_effort": 5,
      "upc_my_completed_effort": 3
    }
  ];
  final stages = [
    {
      "prs_id": "dac72489-37d9-48bf-83d1-4152100bc04c",
      "prj_id": "b25267fd-0937-4983-808e-23e4779e3dc1",
      "prs_path_tree": "path.project_stage1",
      "prs_type": "stage",
      "prs_name": "Project Stage 1",
      "prs_startdate": "2024-01-04",
      "prs_enddate": "2024-01-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 1,
      "prs_total_finished": 0,
      "prs_progress": 0
    },
    {
      "prs_id": "46115eba-d67e-4aeb-8ccd-6fd83a821aad",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1717459200.46115ebad67e4aeb8ccd6fd83a821aad",
      "prs_type": "cycle",
      "prs_name": "Project Stage 6",
      "prs_startdate": "2024-06-04",
      "prs_enddate": "2024-09-02",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 11,
      "prs_total_finished": 6,
      "prs_progress": 35.29
    },
    {
      "prs_id": "d3c94ced-0805-482f-8534-33703dfe075b",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1717459200.46115ebad67e4aeb8ccd6fd83a821aad.1717545600.d3c94ced0805482f853433703dfe075b",
      "prs_type": "sequence",
      "prs_name": "Project Stage 4",
      "prs_startdate": "2024-06-05",
      "prs_enddate": "2024-07-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 8,
      "prs_total_finished": 1,
      "prs_progress": 11.11
    },
    {
      "prs_id": "0db5e8c6-0ebd-4f3e-a9d6-1e4f7eef071f",
      "prj_id": "b25267fd-0937-4983-808e-23e4779e3dc1",
      "prs_path_tree": "path.project_stage7",
      "prs_type": "cycle",
      "prs_name": "Project Stage 7",
      "prs_startdate": "2024-07-01",
      "prs_enddate": "2024-07-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 12,
      "prs_total_finished": 4,
      "prs_progress": 25
    },
    {
      "prs_id": "935eb74a-edd0-4406-aadc-a235a36b80e8",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1723420800.935eb74aedd04406aadca235a36b80e8",
      "prs_type": "sequence",
      "prs_name": "Project Stage 8",
      "prs_startdate": "2024-08-12",
      "prs_enddate": "2024-08-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 13,
      "prs_total_finished": 6,
      "prs_progress": 31.58
    },
    {
      "prs_id": "8cf86ff7-29e5-4578-b9bc-13e0d8982e61",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1723420800.935eb74aedd04406aadca235a36b80e8.1723507200.8cf86ff729e54578b9bc13e0d8982e61",
      "prs_type": "stage",
      "prs_name": "Project Stage 2",
      "prs_startdate": "2024-08-13",
      "prs_enddate": "2024-08-26",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 2,
      "prs_total_finished": 2,
      "prs_progress": 50
    },
    {
      "prs_id": "0f62bf9d-1f45-4788-ba11-b6e77848f28a",
      "prj_id": "c28b6700-27ef-464d-8d4a-d85d64964084",
      "prs_path_tree": "path.project_stage10",
      "prs_type": "sequence",
      "prs_name": "Project Stage 10",
      "prs_startdate": "2024-08-13",
      "prs_enddate": "2024-10-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 4,
      "prs_total_finished": 6,
      "prs_progress": 60
    },
    {
      "prs_id": "ad590ca7-0b34-4150-8198-a805f5c3938a",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1717459200.46115ebad67e4aeb8ccd6fd83a821aad.1723593600.ad590ca70b3441508198a805f5c3938a",
      "prs_type": "stage",
      "prs_name": "Project Stage 5",
      "prs_startdate": "2024-08-14",
      "prs_enddate": "2024-08-30",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 2,
      "prs_total_finished": 4,
      "prs_progress": 66.67
    },
    {
      "prs_id": "d3d91752-c889-465c-a363-c60f46d88614",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1723420800.935eb74aedd04406aadca235a36b80e8.1724025600.d3d91752c889465ca363c60f46d88614",
      "prs_type": "milestone",
      "prs_name": "Project Stage 3",
      "prs_startdate": "2024-08-19",
      "prs_enddate": "2024-08-26",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 8,
      "prs_total_finished": 3,
      "prs_progress": 27.27
    },
    {
      "prs_id": "90ac4771-4c3c-4d14-a197-9099043fe4b8",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "prs_path_tree":
          "29e918454def420e945bfad2c4cb2b2c.1723420800.935eb74aedd04406aadca235a36b80e8.1724025600.d3d91752c889465ca363c60f46d88614.1724198400.90ac47714c3c4d14a1979099043fe4b8",
      "prs_type": "stage",
      "prs_name": "Nouvel élément",
      "prs_startdate": "2024-08-21",
      "prs_enddate": "2024-10-31",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 2,
      "prs_total_finished": 1,
      "prs_progress": 33.33
    },
    {
      "prs_id": "a65538e5-c75f-4d59-8fce-c815fffb650c",
      "prj_id": "b25267fd-0937-4983-808e-23e4779e3dc1",
      "prs_path_tree": "path.project_stage9",
      "prs_type": "stage",
      "prs_name": "Project Stage 9",
      "prs_startdate": "2024-09-09",
      "prs_enddate": "2024-09-30",
      "prs_total_activity": 0,
      "prs_total_activity_finished": 0,
      "prs_total_delivrable": 0,
      "prs_total_delivrable_finished": 0,
      "prs_total_task": 0,
      "prs_total_task_finished": 0,
      "prs_total_pending": 5,
      "prs_total_finished": 8,
      "prs_progress": 61.54
    }
  ];
  final notifications = [
    {
      "usn_id": 6,
      "usp_id": "6f52601e-f241-4ab3-b8f1-458df13e6ab1",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "pre_id": "338b3a26-f2a9-4714-9fc0-f0d535f9de94",
      "rch_id": 1,
      "usn_typeofchange": "INSERT",
      "usn_tablename": "swi_project_elements",
      "usn_rowid": "338b3a26-f2a9-4714-9fc0-f0d535f9de94",
      "usn_date": "2024-08-20T07:38:53+00:00",
      "usn_priority": true,
      "usn_read": false,
      "usn_icon": "activity",
      "usn_name": "Name 1",
      "usn_label": "Label 1",
      "usn_description": "Texte 1",
      "usn_timeline": true
    },
    {
      "usn_id": 7,
      "usp_id": "6f52601e-f241-4ab3-b8f1-458df13e6ab1",
      "prj_id": "29e91845-4def-420e-945b-fad2c4cb2b2c",
      "pre_id": "f9c1f38e-71f6-4d2b-bc6b-3be1529eb1db",
      "rch_id": 2,
      "usn_typeofchange": "UPDATE",
      "usn_tablename": "swi_project_elements",
      "usn_rowid": "f9c1f38e-71f6-4d2b-bc6b-3be1529eb1db",
      "usn_date": "2024-08-20T07:47:57+00:00",
      "usn_priority": true,
      "usn_read": true,
      "usn_icon": "activity",
      "usn_name": "Name 2",
      "usn_label": "Label 2",
      "usn_description": "Texte 2",
      "usn_timeline": true
    }
  ];

  final Map<String, Color> colors = {
    'primary': const Color(0xFFCE49AF),
    'secondary': const Color(0xFFFFC500),
    'primaryText': const Color(0xFFE1E1E1),
    'primaryBackground': const Color(0xFF111A30),
    'accent1': const Color(0xFF818497),
    'accent2': const Color(0xFF5C5E71),
    'error': const Color(0xFFFF5963),
    'warning': const Color(0xFFF9CF58)
  };

  void openDayDetail(String date, double? dayProgress, List<String>? openDayDetail, List<dynamic>? elements) {}

  void openAddStage(String? prsId) {}

  const double width = 300;
  const double height = 480;

  test(
      'Vérifie si le widget se charge',
      () => {
            TimelineXp(
                width: width,
                height: height,
                colors: colors,
                lang: 'fr_FR',
                projectCount: projectCount,
                dateInterval: dateInterval,
                elements: elements,
                capacities: capacities,
                stages: stages,
                notifications: notifications,
                openDayDetail: openDayDetail,
                openAddStage: openAddStage)
          });
}
