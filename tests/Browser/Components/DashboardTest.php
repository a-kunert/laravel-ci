<?php

namespace Tests\Browser\Components;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class DashboardTest extends DuskTestCase
{

    use DatabaseMigrations;

    /** @test */
    public function a_user_can_post_comments()
    {
        $this->browse(function (Browser $browser) {
            $user = User::factory()->create();
            $browser->loginAs($user)->visit('/dashboard')
                ->type('@content','This is a test')
                ->click('@submit')
                ->waitForText('This is a test')
                ->assertSeeIn('@main',$user->name)
                ->assertSeeIn('@main','This is a test');
        });
    }
}
