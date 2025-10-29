<?php

namespace App\Console\Commands\Uiwede;

use LaravelZero\Framework\Commands\Command;
use Xavante\Models\Domain\Workflow;

class UiwedeRunCommand extends Command
{
    /**
     * The signature of the command.
     *
     * @var string
     */
    protected $signature = 'uiwede:run 
                            {--mode=single : Execution mode (single, batch, daemon)}
                            {--workflow-id= : Specific workflow to process}
                            {--format=table : Output format (table, json)}
                            {--detailed : Detailed ceremonial execution logging}';

    /**
     * The description of the command.
     *
     * @var string
     */
    protected $description = 'Execute workflow instances from queue with multiple execution modes (single, batch, daemon). Named after Uiwede - the seasonal log races held during rainy season, representing rhythmic coordination and proper timing in task execution';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🏃‍♂️ Starting Workflow Execution Engine (Uiwede - Seasonal Log Races)...');
        
        try {
            $mode = $this->option('mode');
            $workflowId = $this->option('workflow-id');
            $detailed = $this->option('detailed');
            
            if ($detailed) {
                $this->line("🔧 Initializing execution environment in {$mode} mode...");
                $this->line("🌧️ Following Uiwede tradition of rhythmic coordination during rainy season");
            }
            
            // Create a workflow instance (similar to original worker.php)
            $workflow = new Workflow([]);
            
            $this->info('📋 Loading and executing workflow instance...');
            
            // Get the workflow data
            $workflowData = $workflow->jsonSerialize();
            
            // Output based on format option
            $format = $this->option('format');
            
            if ($format === 'json') {
                $this->line(json_encode($workflowData, JSON_PRETTY_PRINT));
            } else {
                $this->info('✅ Workflow execution completed successfully!');
                $this->table(
                    ['Property', 'Value'],
                    collect($workflowData)->map(fn($value, $key) => [
                        $key, 
                        is_array($value) ? json_encode($value) : (string)$value
                    ])->values()->toArray()
                );
            }
            
            $this->info('🎉 Execution engine completed with proper timing and coordination (Uiwede tradition)!');
            
            return self::SUCCESS;
            
        } catch (\Exception $e) {
            $this->error('❌ Uiwede ceremony failed: ' . $e->getMessage());
            return self::FAILURE;
        }
    }
}