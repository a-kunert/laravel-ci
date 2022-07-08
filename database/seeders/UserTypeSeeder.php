<?php

namespace Database\Seeders;

use App\Models\UserType;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $types = [
            ['id' => 1, 'name' => 'admin', 'role' => 'admin role'],
            ['id' => 2, 'name' => 'contributor', 'role' => 'contributor role']
        ];


        foreach($types as $type) {
            UserType::updateOrCreate(['id' => $type['id']],$type);
        }
    }
}
