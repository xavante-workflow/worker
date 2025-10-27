<?php

namespace Xavante\Worker;

use Xavante\Models\Domain\Workflow;

include_once __DIR__ . '/vendor/autoload.php';

$wf = new Workflow([]);


print_r($wf->jsonSerialize());