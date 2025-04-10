<?php
// super_controller.php
// This controller handles dynamic CRUD operations for base tables and also supports stored procedure “applications”.
// It has been modified so that when the target is a VIEW (or has no primary key), it works in read‑only mode.
// It also allows procedure actions (accion=crear_app) without requiring a "table" parameter.

session_start();
include "config.php";

$mysqli = new mysqli($host, $user, $pass, $dbName);
if ($mysqli->connect_errno) {
    die("Connection Error: " . $mysqli->connect_error);
}

// Determine action: listar, crear, editar, eliminar, crear_foreign, or crear_app (stored procedure)
$accion = isset($_GET['accion']) ? $_GET['accion'] : 'listar';

// For a stored procedure call, we do not require a table parameter.
if ($accion !== 'crear_app') {
    $table = isset($_GET['table']) ? $mysqli->real_escape_string($_GET['table']) : '';
    if (empty($table)) {
        die("No table specified.");
    }
}

// If we are not handling a stored procedure, do the following:
if ($accion !== 'crear_app') {
    // Determine if the target object is a BASE TABLE or a VIEW.
    $tableTypeQuery = "SELECT TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='$dbName' AND TABLE_NAME='$table'";
    $resultTableType = $mysqli->query($tableTypeQuery);
    if ($resultTableType && $rowTableType = $resultTableType->fetch_assoc()) {
        $tableType = $rowTableType['TABLE_TYPE']; // "BASE TABLE" or "VIEW"
    } else {
        $tableType = "BASE TABLE";
    }
    // Create a flag: isView
    $isView = ($tableType !== "BASE TABLE");

    // Fetch optional table comment (for display)
    $tableComment = "";
    $tableCommentQuery = "SELECT TABLE_COMMENT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='$dbName' AND TABLE_NAME='$table'";
    $resultTableComment = $mysqli->query($tableCommentQuery);
    if ($resultTableComment && $rowTable = $resultTableComment->fetch_assoc()) {
        $tableComment = $rowTable['TABLE_COMMENT'];
    }

    // Fetch column metadata for the table (or view)
    $columns = [];
    $columnsQuery = "SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA, COLUMN_KEY, COLUMN_COMMENT 
                     FROM INFORMATION_SCHEMA.COLUMNS 
                     WHERE TABLE_SCHEMA='$dbName' AND TABLE_NAME='$table'";
    $result = $mysqli->query($columnsQuery);
    if (!$result || $result->num_rows == 0) {
        die("Table not found or no columns available.");
    }
    while ($row = $result->fetch_assoc()) {
        $columns[] = $row;
    }

    // Build foreign keys mapping from metadata (if available)
    $foreignKeys = [];
    $fkQuery = "SELECT COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME 
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
                WHERE TABLE_SCHEMA='$dbName' AND TABLE_NAME='$table' AND REFERENCED_TABLE_NAME IS NOT NULL";
    $resultFK = $mysqli->query($fkQuery);
    if ($resultFK) {
        while ($fk = $resultFK->fetch_assoc()) {
            $foreignKeys[$fk['COLUMN_NAME']] = [
                'referenced_table' => $fk['REFERENCED_TABLE_NAME'],
                'referenced_column' => $fk['REFERENCED_COLUMN_NAME']
            ];
        }
    }

    // For base tables, determine the primary key (assumes one primary key)
    if (!$isView) {
        $primaryKey = null;
        foreach ($columns as $col) {
            if ($col['COLUMN_KEY'] === 'PRI') {
                $primaryKey = $col['COLUMN_NAME'];
                break;
            }
        }
        if (!$primaryKey) {
            die("No primary key found for table '$table'.");
        }
    }
}

// Helper function mapping SQL types to HTML input attributes.
function getInputAttributes($dataType) {
    $dataType = strtolower($dataType);
    if (in_array($dataType, ['int', 'bigint', 'smallint', 'mediumint', 'tinyint'])) {
        return ['type' => 'number', 'bind' => 'i'];
    } elseif (in_array($dataType, ['decimal', 'numeric', 'float', 'double'])) {
        return ['type' => 'number', 'bind' => 'd', 'step' => '0.01'];
    } elseif (in_array($dataType, ['date'])) {
        return ['type' => 'date', 'bind' => 's'];
    } elseif (in_array($dataType, ['datetime', 'timestamp'])) {
        return ['type' => 'datetime-local', 'bind' => 's'];
    } elseif (in_array($dataType, ['text', 'mediumtext', 'longtext'])) {
        return ['type' => 'textarea', 'bind' => 's'];
    } else {
        return ['type' => 'text', 'bind' => 's'];
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>
    <?php 
      if ($accion === 'crear_app' && isset($_GET['sp'])) {
          echo "Dynamic CRUD: Procedure " . htmlspecialchars($_GET['sp']);
      } else {
          echo "Dynamic CRUD: " . htmlspecialchars($table);
      }
    ?>
  </title>
  <style>
    /* Basic styling for forms and tables */
    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background: #eee; }
    form { margin-bottom: 20px; }
    label { display: block; margin: 5px 0; }
    input, textarea, select { width: 100%; padding: 5px; box-sizing: border-box; }
    .actions a { margin-right: 5px; text-decoration: none; }
    .column-comment { font-size: 0.85em; color: #666; }
    .crud-form fieldset { margin-bottom: 10px; }
  </style>
</head>
<body>
  <?php
    // Display header
    if ($accion === 'crear_app' && isset($_GET['sp'])) {
        echo "<h2>Stored Procedure Application: " . htmlspecialchars($_GET['sp']) . "</h2>";
    } else {
        echo "<h2>CRUD for table: " . htmlspecialchars($table) . "</h2>";
        if (!empty($tableComment)) { 
            echo "<p><em>" . htmlspecialchars($tableComment) . "</em></p>"; 
        }
    }
  ?>

  <?php if ($accion !== 'crear_app'): ?>
    <?php if (!$isView): ?>
      <p>
        <a href="?table=<?php echo urlencode($table); ?>&accion=crear">+ Crear nuevo registro</a> | 
        <a href="?table=<?php echo urlencode($table); ?>&accion=listar">Listar registros</a>
      </p>
    <?php else: ?>
      <p><strong>Vista de solo lectura</strong></p>
    <?php endif; ?>
    <hr>
  <?php endif; ?>

<?php
switch ($accion) {

  // ----------------------------
  // List all records
  case 'listar':
      $query = "SELECT * FROM `$table` ORDER BY ";
      if (!$isView) {
          $query .= "`$primaryKey` DESC";
      } else {
          // Order by the first column for views
          $query .= "`" . $columns[0]['COLUMN_NAME'] . "` ASC";
      }
      $result = $mysqli->query($query);
      if (!$result) {
          die("Error in query: " . $mysqli->error);
      }
      echo "<h3>Listado de registros</h3>";
      echo "<table>";
      echo "<thead><tr>";
      foreach ($columns as $col) {
          echo "<th>" . htmlspecialchars($col['COLUMN_NAME']) . "</th>";
      }
      if (!$isView) {
          echo "<th>Acciones</th>";
      }
      echo "</tr></thead><tbody>";
      // Cache for foreign key display values
      $fkDisplayCache = array();
      while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          foreach ($columns as $col) {
              $colName = $col['COLUMN_NAME'];
              $val = isset($row[$colName]) ? $row[$colName] : "";
              if (isset($foreignKeys[$colName])) {
                  if (!isset($fkDisplayCache[$colName])) {
                      $fkDisplayCache[$colName] = array();
                  }
                  if (!isset($fkDisplayCache[$colName][$val])) {
                      $refTable = $foreignKeys[$colName]['referenced_table'];
                      $refColumn = $foreignKeys[$colName]['referenced_column'];
                      $fkQuery = "SELECT * FROM `$refTable` WHERE `$refColumn` = '" . $mysqli->real_escape_string($val) . "' LIMIT 1";
                      $fkResult = $mysqli->query($fkQuery);
                      if ($fkResult && $fkResult->num_rows > 0) {
                          $fkRow = $fkResult->fetch_assoc();
                          $displayText = implode(" - ", $fkRow);
                      } else {
                          $displayText = $val;
                      }
                      $fkDisplayCache[$colName][$val] = $displayText;
                  } else {
                      $displayText = $fkDisplayCache[$colName][$val];
                  }
                  echo "<td>" . htmlspecialchars($displayText) . "</td>";
              } else {
                  echo "<td>" . htmlspecialchars($val) . "</td>";
              }
          }
          if (!$isView) {
              echo "<td class='actions'>";
              echo "<a href=\"?table=" . urlencode($table) . "&accion=editar&id=" . urlencode($row[$primaryKey]) . "\">✏ Editar</a>";
              echo "<a href=\"?table=" . urlencode($table) . "&accion=eliminar&id=" . urlencode($row[$primaryKey]) . "\" onclick=\"return confirm('¿Eliminar este registro?');\">❌ Eliminar</a>";
              echo "</td>";
          }
          echo "</tr>";
      }
      echo "</tbody></table>";
      break;

  // ----------------------------
  // Create new record (Form A)
  case 'crear':
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
          $_SESSION['formA_data'] = $_POST;
          $fields = [];
          $placeholders = [];
          $types = "";
          $values = [];
          foreach ($columns as $col) {
              if (strpos($col['EXTRA'], "auto_increment") !== false) continue;
              $colName = $col['COLUMN_NAME'];
              $defaultValue = "";
              if (isset($_GET[$colName])) {
                  $defaultValue = $_GET[$colName];
              }
              if (isset($_SESSION['formA_data'][$colName])) {
                  $defaultValue = $_SESSION['formA_data'][$colName];
              }
              if (isset($_GET['new_' . $colName])) {
                  $defaultValue = $_GET['new_' . $colName];
              }
              $attrs = getInputAttributes($col['DATA_TYPE']);
              if (($attrs['type'] === 'date' || $attrs['type'] === 'datetime-local') && trim($defaultValue) === '') {
                  $defaultValue = ($attrs['type'] === 'date') ? date('Y-m-d') : date('Y-m-d\TH:i');
              }
              $fields[] = "`$colName`";
              $placeholders[] = "?";
              $types .= $attrs['bind'];
              $values[] = $defaultValue;
          }
          if (count($fields) > 0) {
              $sql = "INSERT INTO `$table` (" . implode(", ", $fields) . ") VALUES (" . implode(", ", $placeholders) . ")";
              $stmt = $mysqli->prepare($sql);
              if (!$stmt) {
                  die("Prepare failed: " . $mysqli->error);
              }
              $bind_names = [];
              $bind_names[] = $types;
              for ($i = 0; $i < count($values); $i++) {
                  $bind_names[] = &$values[$i];
              }
              call_user_func_array(array($stmt, 'bind_param'), $bind_names);
              if (!$stmt->execute()) {
                  die("Execute failed: " . $stmt->error);
              }
              $stmt->close();
          }
          unset($_SESSION['formA_data']);
          echo '<script>window.location = "?table=' . urlencode($table) . '&accion=listar"</script>';
          exit;
      } else {
          $savedData = isset($_SESSION['formA_data']) ? $_SESSION['formA_data'] : [];
          echo "<h3>Crear Nuevo Registro</h3>";
          echo "<form method='post' action='?table=" . urlencode($table) . "&accion=crear' class='crud-form'>";
          foreach ($columns as $col) {
              if (strpos($col['EXTRA'], "auto_increment") !== false) continue;
              echo "<fieldset>";
              $colName = $col['COLUMN_NAME'];
              $attrs = getInputAttributes($col['DATA_TYPE']);
              $defaultValue = "";
              if (isset($_GET[$colName])) {
                  $defaultValue = $_GET[$colName];
              }
              if (isset($savedData[$colName])) {
                  $defaultValue = $savedData[$colName];
              }
              if (isset($_GET['new_' . $colName])) {
                  $defaultValue = $_GET['new_' . $colName];
              }
              echo "<label>" . htmlspecialchars($colName) . ":";
              if (!empty($col['COLUMN_COMMENT'])) {
                  echo "<br><span class='column-comment'>" . htmlspecialchars($col['COLUMN_COMMENT']) . "</span>";
              }
              echo "</label>";
              if (isset($foreignKeys[$colName])) {
                  $ref = $foreignKeys[$colName];
                  $refTable = $ref['referenced_table'];
                  $refColumn = $ref['referenced_column'];
                  $fkQuery = "SELECT * FROM `$refTable`";
                  $fkResult = $mysqli->query($fkQuery);
                  echo "<select name='" . htmlspecialchars($colName) . "'>";
                  while ($fkRow = $fkResult->fetch_assoc()) {
                      $optionValue = $fkRow[$refColumn];
                      $optionText = implode(" - ", array_map('htmlspecialchars', $fkRow));
                      $selected = ($defaultValue !== "" && $defaultValue == $optionValue) ? "selected" : "";
                      echo "<option value=\"" . htmlspecialchars($optionValue) . "\" $selected>" . $optionText . "</option>";
                  }
                  echo "</select>";
                  $currentUrl = $_SERVER['REQUEST_URI'];
                  $encodedUrl = urlencode($currentUrl);
                  echo ' <a href="?table=' . urlencode($table) .
                       '&accion=crear_foreign'
                       . '&foreign_field=' . urlencode($colName)
                       . '&foreign_table=' . urlencode($refTable)
                       . '&return_url=' . $encodedUrl
                       . '">+</a>';
              } else {
                  if ($attrs['type'] === 'textarea') {
                      echo "<textarea name='" . htmlspecialchars($colName) . "'>" . htmlspecialchars($defaultValue) . "</textarea>";
                  } else {
                      echo "<input type='" . htmlspecialchars($attrs['type']) . "' name='" . htmlspecialchars($colName) . "' value='" . htmlspecialchars($defaultValue) . "'";
                      if (isset($attrs['step'])) {
                          echo " step='" . htmlspecialchars($attrs['step']) . "'";
                      }
                      echo ">";
                  }
              }
              echo "</fieldset>";
          }
          echo "<br><button type='submit'>Crear</button>";
          echo "</form>";
      }
      break;

  // ----------------------------
  // Edit existing record (Form B)
  case 'editar':
      if (!isset($_GET['id'])) {
          die("No ID provided for edit.");
      }
      $id = $mysqli->real_escape_string($_GET['id']);
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
          $setClauses = [];
          $types = "";
          $values = [];
          foreach ($columns as $col) {
              if ($col['COLUMN_NAME'] === $primaryKey && strpos($col['EXTRA'], "auto_increment") !== false) continue;
              $colName = $col['COLUMN_NAME'];
              if (isset($_POST[$colName])) {
                  $setClauses[] = "`$colName` = ?";
                  $attrs = getInputAttributes($col['DATA_TYPE']);
                  $types .= $attrs['bind'];
                  $values[] = $_POST[$colName];
              }
          }
          $types .= "i";
          $values[] = $id;
          $sql = "UPDATE `$table` SET " . implode(", ", $setClauses) . " WHERE `$primaryKey` = ?";
          $stmt = $mysqli->prepare($sql);
          if (!$stmt) {
              die("Prepare failed: " . $mysqli->error);
          }
          $bind_names = [];
          $bind_names[] = $types;
          for ($i = 0; $i < count($values); $i++) {
              $bind_names[] = &$values[$i];
          }
          call_user_func_array(array($stmt, 'bind_param'), $bind_names);
          if (!$stmt->execute()) {
              die("Execute failed: " . $stmt->error);
          }
          $stmt->close();
          header("Location: ?table=" . urlencode($table) . "&accion=listar");
          exit;
      } else {
          $query = "SELECT * FROM `$table` WHERE `$primaryKey` = '$id' LIMIT 1";
          $result = $mysqli->query($query);
          if (!$result || $result->num_rows == 0) {
              die("Record not found.");
          }
          $record = $result->fetch_assoc();
          echo "<h3>Editar Registro (ID: " . htmlspecialchars($id) . ")</h3>";
          echo "<form method='post' action='?table=" . urlencode($table) . "&accion=editar&id=" . urlencode($id) . "' class='crud-form'>";
          foreach ($columns as $col) {
              if ($col['COLUMN_NAME'] === $primaryKey && strpos($col['EXTRA'], "auto_increment") !== false) {
                  echo "<fieldset>";
                  echo "<p><strong>" . htmlspecialchars($col['COLUMN_NAME']) . ":</strong> " . htmlspecialchars($record[$col['COLUMN_NAME']]) . "</p>";
                  echo "</fieldset>";
                  continue;
              }
              echo "<fieldset>";
              $colName = $col['COLUMN_NAME'];
              $attrs = getInputAttributes($col['DATA_TYPE']);
              $value = isset($record[$colName]) ? $record[$colName] : "";
              if ($attrs['type'] === 'datetime-local') {
                  $value = str_replace(' ', 'T', $value);
              }
              echo "<label>" . htmlspecialchars($colName) . ":";
              if (!empty($col['COLUMN_COMMENT'])) {
                  echo "<br><span class='column-comment'>" . htmlspecialchars($col['COLUMN_COMMENT']) . "</span>";
              }
              echo "</label>";
              if (isset($foreignKeys[$colName])) {
                  $ref = $foreignKeys[$colName];
                  $refTable = $ref['referenced_table'];
                  $refColumn = $ref['referenced_column'];
                  $dispColQuery = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='$dbName' AND TABLE_NAME='$refTable' AND COLUMN_KEY <> 'PRI' ORDER BY ORDINAL_POSITION LIMIT 1";
                  $dispColRes = $mysqli->query($dispColQuery);
                  if ($dispColRes && $dispRow = $dispColRes->fetch_assoc()) {
                      $displayColumn = $dispRow['COLUMN_NAME'];
                  } else {
                      $displayColumn = $refColumn;
                  }
                  $fkQuery = "SELECT `$refColumn` as ref_val, `$displayColumn` as ref_disp FROM `$refTable`";
                  $fkResult = $mysqli->query($fkQuery);
                  echo "<select name='" . htmlspecialchars($colName) . "'>";
                  while ($fkRow = $fkResult->fetch_assoc()) {
                      $selected = ($fkRow['ref_val'] == $value) ? "selected" : "";
                      echo "<option value=\"" . htmlspecialchars($fkRow['ref_val']) . "\" $selected>" . htmlspecialchars($fkRow['ref_disp']) . "</option>";
                  }
                  echo "</select>";
              } else {
                  if ($attrs['type'] === 'textarea') {
                      echo "<textarea name='" . htmlspecialchars($colName) . "'>" . htmlspecialchars($value) . "</textarea>";
                  } else {
                      echo "<input type='" . htmlspecialchars($attrs['type']) . "' name='" . htmlspecialchars($colName) . "' value=\"" . htmlspecialchars($value) . "\"";
                      if (isset($attrs['step'])) {
                          echo " step='" . htmlspecialchars($attrs['step']) . "'";
                      }
                      echo ">";
                  }
              }
              echo "</fieldset>";
          }
          echo "<br><button type='submit'>Guardar Cambios</button>";
          echo "</form>";
      }
      break;

  // ----------------------------
  // Delete record
  case 'eliminar':
      if (!isset($_GET['id'])) {
          die("No ID provided for deletion.");
      }
      $id = $mysqli->real_escape_string($_GET['id']);
      $sql = "DELETE FROM `$table` WHERE `$primaryKey` = ?";
      $stmt = $mysqli->prepare($sql);
      if (!$stmt) {
          die("Prepare failed: " . $mysqli->error);
      }
      $stmt->bind_param("i", $id);
      if (!$stmt->execute()) {
          die("Deletion failed: " . $stmt->error);
      }
      $stmt->close();
      echo '<script>window.location = "?table=' . urlencode($table) . '&accion=listar"</script>';
      exit;
      break;

  // ----------------------------
  // Create new foreign record (crear_foreign)
  case 'crear_foreign':
      // For brevity, you can incorporate the original foreign key record creation code here.
      echo "<p>La funcionalidad para crear registros foráneos aún no está implementada en este código ejemplo.</p>";
      break;

  // ----------------------------
  // Stored Procedure Application (crear_app)
  case 'crear_app':
      if (!isset($_GET['sp'])) {
          die("No stored procedure specified.");
      }
      $spName = $mysqli->real_escape_string($_GET['sp']);
      // Obtain IN parameters for the stored procedure.
      $spParamsQuery = "SELECT PARAMETER_NAME, DATA_TYPE
                        FROM INFORMATION_SCHEMA.PARAMETERS 
                        WHERE SPECIFIC_SCHEMA='$dbName' 
                          AND SPECIFIC_NAME='$spName' 
                          AND PARAMETER_MODE='IN'
                        ORDER BY ORDINAL_POSITION";
      $spParamsResult = $mysqli->query($spParamsQuery);
      if (!$spParamsResult || $spParamsResult->num_rows == 0) {
          echo "No parameters found for stored procedure '$spName'.";
          break;
      }
      $spParams = [];
      while ($paramRow = $spParamsResult->fetch_assoc()) {
          $paramName = ltrim($paramRow['PARAMETER_NAME'], '@');
          $spParams[] = [
              'name' => $paramName,
              'data_type' => $paramRow['DATA_TYPE']
          ];
      }
      // Process form submission.
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
          $paramPlaceholders = [];
          $paramTypes = "";
          $paramValues = [];
          foreach ($spParams as $param) {
              $pname = $param['name'];
              $paramPlaceholders[] = "?";
              // Bind all values as strings for simplicity.
              $paramTypes .= "s";
              $paramValues[] = isset($_POST[$pname]) ? $_POST[$pname] : '';
          }
          $stmt = $mysqli->prepare("CALL $spName(" . implode(",", $paramPlaceholders) . ")");
          if (!$stmt) {
              die("Prepare failed: " . $mysqli->error);
          }
          $bind_names = [];
          $bind_names[] = $paramTypes;
          for ($i = 0; $i < count($paramValues); $i++) {
              $bind_names[] = &$paramValues[$i];
          }
          call_user_func_array(array($stmt, 'bind_param'), $bind_names);
          if (!$stmt->execute()) {
              die("Stored procedure execution failed: " . $stmt->error);
          }
          $stmt->close();
          echo "<p>Registro insertado mediante procedimiento almacenado '$spName'.</p>";
          break;
      } else {
          echo "<h3>Crear registro (Procedimiento: $spName)</h3>";
          echo "<form method='post' action='?accion=crear_app&sp=" . urlencode($spName) . "' class='crud-form'>";
          foreach ($spParams as $param) {
              echo "<fieldset>";
              echo "<label>" . htmlspecialchars($param['name']) . " (" . htmlspecialchars($param['data_type']) . "):</label>";
              echo "<input type='text' name='" . htmlspecialchars($param['name']) . "' required>";
              echo "</fieldset>";
          }
          echo "<br><button type='submit'>Crear mediante procedimiento</button>";
          echo "</form>";
      }
      break;

  default:
      echo "<p>Acción no reconocida.</p>";
      break;
}
$mysqli->close();
?>
</body>
</html>

