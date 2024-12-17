def format_date [date] -> str {
  $date | date humanize
}

def get_running_tasks [tasks: list] -> list {
  mut list = []

  mut tasks = $tasks

  for index in 0..(($tasks | length) - 1) {
    let entry = $tasks | get $index

    if "start" in $entry {
      mut mod_entry = $entry
      $mod_entry.index = $index
      $list = $list | append $mod_entry
    }
  }

  if ($list | length) != 0 {
    
    for index in 0..(($list | length) - 1) {
      let entry = $list | get $index

      $tasks = $tasks | drop nth $entry.index
    }
  }

  {
    running: $list,
    all: $tasks
  }
}

def get_format_settings [default: bool = true] -> settings {
  {
    urgency: $default
    tags: $default
    project: $default
    description: $default
    id: $default
    due: $default
    scheduled: $default
    running: $default
  }
}

def format_entry [
    entry
    settings?
  ] -> str {

  let $settings = match $settings {
    null => (get_format_settings true)
    _ => $settings
  }

  # print $"format_entry: settings = ($settings)\nformat_entry: entry = ($entry)"

  let strings = [
    (
      if $settings.urgency {
        $"\(Prio: ($entry.urgency)\)"
      }
    )
    (
      if $settings.tags and "tags" in $entry {
        $"[($entry.tags | str join ', ')]"
      }
    )
    (
      if $settings.project and "project" in $entry {
        $"[($entry.project)]"
      }
    )
    (
      if $settings.description {
        $"\'($entry.description)\'"
      }
    )
    (
      if $settings.id {
        $"\(ID: ($entry.id)\)"
      }
    )
    (      
      if $settings.due and "due" in $entry {
        $"| due (format_date $entry.due)"
      }
    )
    (
      if $settings.scheduled and "scheduled" in $entry {
        $"| scheduled (format_date $entry.scheduled)"
      }
    )
    (      
      if $settings.running and "start" in $entry {
        $"| running since (format_date $entry.start)"
      }  
    )
  ]

  $strings | compact | str join ' '
}

def format_rest [tasks: list] -> json {
  let length = $tasks | length

  if $length < 1 {
    return [ "No more tasks!" ]
  }

  mut big_list = []

  for index in 1..$length {
    let entry = $tasks | get ($index - 1)
    # let string = $"- \(($entry.urgency)\) (if "tags" in $entry { [($entry.tags | str join ', ')] }) \'($entry.description)\' (if "due" in $entry { 'due ' + ($entry.due | date humanize) + ' '})(if "scheduled" in $entry { 'scheduled ' + (format_date $entry.scheduled) + ' '})(if "start" in $entry { 'running since ' + (format_date $entry.start) + ' '})"
    let string = $"- (format_entry $entry)"
    $big_list = ($big_list | append $string)
  }

  $big_list
}


def main [] {
  mut all_tasks = (task export | from json | where status != "deleted" and status != "completed" | sort-by urgency | reverse)

  let result = get_running_tasks $all_tasks
  let running_tasks = $result.running
  $all_tasks = $result.all
  if ($running_tasks | length) > 0 {
    let entry = $running_tasks.0

    mut formatting = get_format_settings false

    $formatting.description = true
    $formatting.id = true
    $formatting.running = true
   
    return ({
      text: $"Current running task: (format_entry $entry $formatting)",
      tooltip: (format_rest $all_tasks | str join "\n")
    } | to json -r)
  }

  mut string = "No task found"

  if ($all_tasks | length) > 0 {
    let most_urgent = $all_tasks.0

    mut formatting = get_format_settings true

    $formatting.id = false
    
    $all_tasks = $all_tasks | skip 1
    $string = $"Most urgent task: (format_entry $most_urgent $formatting)"
  }

  { 
    text: $string, 
    tooltip: (format_rest $all_tasks | str join "\n"),
  } | to json -r
}
