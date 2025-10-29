<?php

namespace App\Console\Commands;

use LaravelZero\Framework\Commands\Command;

class AppVersionCommand extends Command
{
    /**
     * The signature of the command.
     *
     * @var string
     */
    protected $signature = 'app:version';

    /**
     * The description of the command.
     *
     * @var string
     */
    protected $description = 'Display the application version';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $name = config('app.name', 'Xavante Worker');
        $version = config('app.version', '1.0.0');
        
        $this->line("$name $version");
        
        return self::SUCCESS;
    }
}