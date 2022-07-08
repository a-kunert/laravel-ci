<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserType extends Model
{
    use HasFactory;

    public $timestamps = false;

    public const DEFAULT_TYPE_ID = 2;

    public static function default()
    {
        return static::find(static::DEFAULT_TYPE_ID);
    }
}
