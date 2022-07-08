<?php

namespace Tests\Browser;

use App\Models\UserType;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class ExampleTest extends DuskTestCase
{
    use DatabaseMigrations;

    /**
     * A basic browser test example.
     *
     * @return void
     */
    public function testBasicExample()
    {
        echo(env('APP_ENV')."\n");
        echo(env('DB_DATABASE')."\n");
        $this->browse(function (Browser $browser) {
            $browser->visit('/')
                ->assertSee('Laravel')
                ->visit('/register')
                ->assertSee('Confirm Password');
        });
    }

    public function testFailedRegister()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/register')
                ->type('#name','My Name')
                ->type('#email','test@test.com')
                ->type('#password',"2")
                ->type('#password_confirmation',"3")
                ->press('button[type="submit"]')
                ->pause(100)
                ->assertSee('does not match')
                ->screenshot('SeeValidationError');

        });
    }

    public function testRegister()
    {

        $this->browse(function (Browser $browser) {
            $browser->visit('/register')
                ->type('#name','My Name')
                ->type('#email','test@test.com')
                ->type('#password',"my_password")
                ->type('#password_confirmation',"my_password")
                ->press('button[type="submit"]')
                ->pause(500)
                ->assertSee('You\'re logged in')
                ->screenshot('RegisterCompleted');

        });
    }


}
