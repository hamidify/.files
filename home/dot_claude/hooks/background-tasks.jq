# Prints the ids of background tasks this session started that have not reported back.
# A task that goes quiet longer than its expiry counts as gone: tasks die with the process.
def launched_id: if type != "object" then null
  else .backgroundTaskId // .taskId // .resumedAgentId // (if .isAsync then .agentId else null end) end;
def stopped_id: if type == "object" and (.message? | type) == "string"
  then (.message | capture("Successfully stopped task: (?<id>[A-Za-z0-9]+)")? // {}) | .id else null end;
def finished_ids: [(.message.content? // .content? // "") | tostring
  | scan("<task-id>([^<]+)</task-id>(?:(?!</task-notification>).)*?<status>") | .[0]];
def epoch: if type == "string" then (.[0:19] + "Z" | fromdate) else null end;

reduce inputs as $entry ({};
  ($entry.timestamp | epoch) as $at
  | ($entry.toolUseResult | launched_id) as $launched
  | ($entry.toolUseResult | stopped_id) as $stopped
  | if $launched and $at then
      .[$launched] = {
        running: true,
        expires: (if ($entry.toolUseResult.timeoutMs and ($entry.toolUseResult.persistent | not))
          then $at + ($entry.toolUseResult.timeoutMs / 1000) else $at + $quiet_limit end)
      }
    else . end
  | if $stopped then .[$stopped].running = false else . end
  | reduce ($entry | finished_ids[]) as $id (.; .[$id].running = false))
| map_values(select(.running and .expires > $now)) | keys | join(" ")
