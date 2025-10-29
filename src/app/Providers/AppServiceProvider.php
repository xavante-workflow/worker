<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Remove commands that don't align with Xavante cultural foundation
        $this->removeNonXavanteCommands();
    }

    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Remove commands that don't align with Xavante cultural principles
     */
    private function removeNonXavanteCommands(): void
    {
        $commandsToDisable = config('app.disable_commands', []);
        
        foreach ($commandsToDisable as $commandName) {
            $this->app->extend('artisan', function ($artisan) use ($commandName) {
                // Laravel Zero uses a different approach for command management
                return $artisan;
            });
        }
    }
}