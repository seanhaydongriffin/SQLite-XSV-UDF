#AutoIt3Wrapper_UseX64=y
#include "SQLite-XSV.au3"

_SQLite_XSV_Startup()

QueryRecordsTimed("Release.csv", Default, "all", True)
QueryRecordsTimed("Item.csv", 'select * from data where Name = "DKT-065"', 4, True)
QueryRecordsTimed("Item.csv", Default, "all", False)

QueryRecordTimed("Item.csv", "SELECT * FROM data WHERE ""Identifier"" = 'practice-test-module-002185'")
QueryValueTimed("Release.csv", "SELECT ""Parameter Value"" FROM data WHERE ""Parameter Name"" = 'Test Environment'")

_SQLite_XSV_Shutdown()

Func QueryRecordsTimed($csv_file, $query, $expected_record_count, $display_result)

	$t = TimerInit()

	_SQLite_XSV_Open($csv_file)
	Local $csv_result = _SQLite_XSV_QueryRecords($query, True)

	ConsoleWrite(@CRLF & "Querying " & $expected_record_count & " records from a csv file with " & _FileCountLines($csv_file) & " took: " & TimerDiff($t) & " ms" & @CRLF & @CRLF)

	if $display_result Then _SQLite_XSV_DisplayArrayResult($csv_result)
	_SQLite_XSV_Close()

EndFunc

Func QueryRecordTimed($csv_file, $query)

	$t = TimerInit()

	_SQLite_XSV_Open($csv_file)
	$data = _SQLite_XSV_QueryRecord($query)

	ConsoleWrite(@CRLF & "Querying a single record from a csv file with " & _FileCountLines($csv_file) & " took: " & TimerDiff($t) & " ms" & @CRLF & @CRLF)

	$field_separator = ""
	for $each in $data
		ConsoleWrite($field_separator & $data.Item($each))
		if $field_separator = "" Then $field_separator = ","
	Next
	ConsoleWrite(@CRLF)

	_SQLite_XSV_Close()

EndFunc

Func QueryValueTimed($csv_file, $query)

	$t = TimerInit()

	_SQLite_XSV_Open($csv_file)
	$data = _SQLite_XSV_QueryValue("SELECT ""Parameter Value"" FROM data WHERE ""Parameter Name"" = 'Test Environment'")

	ConsoleWrite(@CRLF & "Querying a single record from a csv file with " & _FileCountLines($csv_file) & " took: " & TimerDiff($t) & " ms" & @CRLF & @CRLF)

	if $data <> Null Then ConsoleWrite($data & @CRLF)

	_SQLite_XSV_Close()

EndFunc
