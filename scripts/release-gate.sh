#!/usr/bin/env bash
# Pre-release validation for Magento Marketplace packaging (EQP prep).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== Marketplace release gate: $(basename "$ROOT") ==="

if [[ ! -f composer.json ]]; then
  echo "Missing composer.json" >&2
  exit 1
fi

php -r '
$path = "composer.json";
$j = json_decode(file_get_contents($path), true, 512, JSON_THROW_ON_ERROR);
$errors = [];
if (($j["type"] ?? "") !== "magento2-module") {
    $errors[] = "type must be magento2-module";
}
if (empty($j["require"]["php"])) {
    $errors[] = "require.php is required for Marketplace";
}
if (empty($j["require"]["magento/framework"])) {
    $errors[] = "require.magento/framework is required for Marketplace";
}
if (isset($j["source"]) || isset($j["dist"])) {
    $errors[] = "composer.json must not contain source or dist keys (EQP)";
}
$files = $j["autoload"]["files"] ?? [];
if (!in_array("registration.php", $files, true)) {
    $errors[] = "autoload.files must include registration.php";
}
if (empty($j["autoload"]["psr-4"])) {
    $errors[] = "autoload.psr-4 must declare at least one namespace";
}
if (!is_file("registration.php")) {
    $errors[] = "registration.php is missing";
}
if (!is_file("etc/module.xml")) {
    $errors[] = "etc/module.xml is missing";
}
if (!is_file("LICENSE.txt")) {
    $errors[] = "LICENSE.txt is missing (must match license in composer.json)";
}
if ($errors) {
    foreach ($errors as $e) {
        fwrite(STDERR, "composer.json: $e\n");
    }
    exit(1);
}
echo "composer.json: OK\n";
'

echo "PHP syntax lint..."
find "$ROOT" -name '*.php' -not -path '*/vendor/*' -print0 | while IFS= read -r -d '' f; do
  php -l "$f" >/dev/null
done
echo "PHP lint: OK"

echo "Release gate passed."
