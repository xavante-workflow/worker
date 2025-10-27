<?php

namespace App\Console\Commands;

use LaravelZero\Framework\Commands\Command;
use Xavante\Models\Domain\Workflow;

class WorkerCommand extends Command
{
    /**
     * The signature of the command.
     *
     * @var string
     */
    protected $signature = 'worker:run 
                            {--format=table : Output format (table, json)}';

    /**
     * The description of the command.
     *
     * @var string
     */
    protected $description = 'Run the Xavante Worker to process workflows';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🚀 Starting Xavante Worker...');
        
        try {
            // Create a workflow instance (similar to original worker.php)
            $workflow = new Workflow([]);
            
            $this->info('📋 Processing workflow...');
            
            // Get the workflow data
            $workflowData = $workflow->jsonSerialize();
            
            // Output based on format option
            $format = $this->option('format');
            
            if ($format === 'json') {
                $this->line(json_encode($workflowData, JSON_PRETTY_PRINT));
            } else {
                $this->info('✅ Workflow processed successfully!');
                $this->table(
                    ['Property', 'Value'],
                    collect($workflowData)->map(fn($value, $key) => [
                        $key, 
                        is_array($value) ? json_encode($value) : (string)$value
                    ])->values()->toArray()
                );
            }
            
            $this->info('🎉 Xavante Worker completed successfully!');
            
            return self::SUCCESS;
            
        } catch (\Exception $e) {
            $this->error('❌ Error running worker: ' . $e->getMessage());
            return self::FAILURE;
        }
    }
}